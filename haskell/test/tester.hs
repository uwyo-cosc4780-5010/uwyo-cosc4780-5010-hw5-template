{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE ViewPatterns #-}

module Main where

import Control.Monad (foldM)
import Data.Char
import Data.List
import Debug.Trace
import System.Console.ANSI
import System.Directory
import System.Environment
import System.Exit
import System.FilePath
import System.IO
import System.Process

main :: IO ()
main = do
  wd <- getCurrentDirectory
  args <- getArgs
  case args of
    "haskell" : "grad" : _ -> run True $ takeDirectory wd </> "ccpp"
    "haskell" : _ -> run False $ takeDirectory wd </> "ccpp"
    "java" : "grad" : _ -> run True "java"
    "java" : _ -> run False "java"
    _ -> die "tester: bad arguments\nusage: tester <haskell | java> [grad]"

toCompileProcess :: String -> String -> IO CreateProcess
toCompileProcess exe sourceFile = do
  wd <- getCurrentDirectory
  return $
    CreateProcess
      { cmdspec =
          RawCommand
            exe
            (["Main" | exe == "java"] ++ [wd </> sourceFile]),
        cwd = Just $ takeDirectory wd,
        env = Nothing,
        std_in = CreatePipe,
        std_out = CreatePipe,
        std_err = CreatePipe,
        close_fds = False,
        create_group = False,
        delegate_ctlc = False,
        detach_console = False,
        create_new_console = False,
        new_session = False,
        child_group = Nothing,
        child_user = Nothing,
        use_process_jobs = False
      }

asmProcess :: String -> IO CreateProcess
asmProcess sourceFile = do
  wd <- getCurrentDirectory
  return $
    CreateProcess
      { cmdspec =
          RawCommand "python3" [wd </> "Krakatau" </> "assemble.py", "cpp.j"],
        cwd = Just $ takeDirectory sourceFile,
        env = Nothing,
        std_in = CreatePipe,
        std_out = CreatePipe,
        std_err = CreatePipe,
        close_fds = False,
        create_group = False,
        delegate_ctlc = False,
        detach_console = False,
        create_new_console = False,
        new_session = False,
        child_group = Nothing,
        child_user = Nothing,
        use_process_jobs = False
      }

javaProcess :: String -> CreateProcess
javaProcess sourceFile =
  CreateProcess
    { cmdspec =
        RawCommand "java" ["cpp"],
      cwd = Just $ takeDirectory sourceFile,
      env = Nothing,
      std_in = CreatePipe,
      std_out = CreatePipe,
      std_err = CreatePipe,
      close_fds = False,
      create_group = False,
      delegate_ctlc = False,
      detach_console = False,
      create_new_console = False,
      new_session = False,
      child_group = Nothing,
      child_user = Nothing,
      use_process_jobs = False
    }

testsInDir :: FilePath -> IO [FilePath]
testsInDir dir = sortOn ((read :: String -> Int) . takeWhile isDigit . takeFileName) . fmap (dir </>) <$> (filter (isSuffixOf ".cc") <$> listDirectory dir)

ugradPoints = 5

gradPoints = 3

run :: Bool -> String -> IO ()
run testGrad haskellJava =
  do
    good <- fmap ((ExitSuccess,) . (,ugradPoints)) <$> testsInDir "good"
    gradGood <- fmap ((ExitSuccess,) . (,gradPoints)) <$> testsInDir ("grad" </> "good")
    bad <- fmap ((ExitFailure 2,) . (,ugradPoints)) <$> testsInDir "bad"
    gradBad <- fmap ((ExitFailure 2,) . (,gradPoints)) <$> testsInDir ("grad" </> "bad")
    let total = sum $ map (snd . snd) (bad ++ good ++ [t | testGrad, t <- gradGood ++ gradBad])
    goodScore <- foldM (\score t@(expect, (fp, worth)) -> toCompileProcess haskellJava fp >>= \p -> runFile total p score t) 0 (good ++ [t | testGrad, t <- gradGood])
    badScore <- foldM (\score t@(expect, (fp, worth)) -> toCompileProcess haskellJava fp >>= \p -> runFile total p score t) goodScore (bad ++ [t | testGrad, t <- gradBad])
    putStrLn ""
    setSGR [SetColor Foreground Vivid Blue]
    putStrLn $ "testing complete, final (tentative) score: " ++ show badScore ++ "/" ++ show total
    setSGR [Reset]

runFile :: Int -> CreateProcess -> Int -> (ExitCode, (FilePath, Int)) -> IO Int
runFile total process score (expect, (filename, worth)) =
  let javaProc = javaProcess filename
   in do
        removePathForcibly (takeDirectory filename </> "cpp.class")
        putStrLn $ "compiling file: " ++ filename ++ " ... "
        (Just cstdin, Just cstdout, Just cstderr, compileProcH) <- createProcess process
        waitForProcess compileProcH >>= \case
          ExitFailure n ->
            if expect `matches` ExitFailure n
              then do
                setSGR [SetColor Foreground Dull Green]
                putStrLn $ "test passed! score: " ++ show (score + worth) ++ "/" ++ show total
                setSGR [Reset]
                return $ score + worth
              else do
                setSGR [SetColor Foreground Vivid Red]
                putStrLn $ "test failed to compile! score: " ++ show score ++ "/" ++ show total
                setSGR [Reset]
                output <- hGetContents cstdout
                errOutput <- hGetContents cstderr
                putStrLn "    compiler standard output:"
                putStrLn (unlines . map ("    " ++) $ lines output)
                putStrLn "    compiler standard error:"
                putStrLn (unlines . map ("    " ++) $ lines errOutput)
                return score
          ExitSuccess -> do
            asmProc <- asmProcess filename
            (Just astdin, Just astdout, Just astderr, asmProcH) <- createProcess asmProc
            waitForProcess asmProcH >>= \case
              ExitFailure n -> do
                setSGR [SetColor Foreground Vivid Red]
                putStrLn $ "failed to assemble compiler output! score: " ++ show score ++ "/" ++ show total
                setSGR [Reset]
                return score
              ExitSuccess -> do
                input <- readFile (filename ++ ".in")
                source <- readFile filename
                (Just jstdin, Just jstdout, Just jstderr, javaProcH) <- createProcess javaProc
                hPutStr jstdin input
                exitCode <- waitForProcess javaProcH
                output <- hGetContents jstdout
                err <- hGetContents jstderr
                outputGolden <- readFile (filename ++ ".out")
                if not $ exitCode `matches` expect
                  then do
                    setSGR [SetColor Foreground Vivid Red]
                    print exitCode
                    print expect
                    putStrLn $ "test failed! score: " ++ show score ++ "/" ++ show total
                    setSGR [Reset]
                    putStrLn $ "    expected JVM program to " ++ (if expect == ExitSuccess then "succeed, but it failed!" else "fail, but it succeeded!")
                    putStrLn "    JVM standard output:"
                    putStrLn (unlines . map ("    " ++) $ lines output)
                    putStrLn "    JVM standard error:"
                    putStrLn (unlines . map ("    " ++) $ lines err)
                    return score
                  else
                    if exitCode `matches` ExitFailure 2
                      then do
                        setSGR [SetColor Foreground Dull Green]
                        putStrLn $ "test passed! score: " ++ show (score + worth) ++ "/" ++ show total
                        setSGR [Reset]
                        return $ score + worth
                      else
                        if output /= outputGolden
                          then do
                            setSGR [SetColor Foreground Vivid Red]
                            putStrLn $ "test failed! score: " ++ show score ++ "/" ++ show total
                            setSGR [Reset]
                            putStrLn "    JVM standard output:"
                            putStrLn (unlines . map ("    " ++) $ lines output)
                            putStrLn "    expected output:"
                            putStrLn (unlines . map ("    " ++) $ lines outputGolden)
                            return score
                          else do
                            setSGR [SetColor Foreground Dull Green]
                            putStrLn $ "test passed! score: " ++ show (score + worth) ++ "/" ++ show total
                            setSGR [Reset]
                            return $ score + worth

matches :: ExitCode -> ExitCode -> Bool
matches ExitSuccess ExitSuccess = True
matches (ExitFailure _) (ExitFailure _) = True
matches _ _ = False

failed :: ExitCode -> Bool
failed (ExitFailure _) = True
failed _ = False