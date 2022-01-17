{-# LANGUAGE TupleSections #-}

module Main where

import Control.Monad (foldM)
import Data.Char
import Data.List
import System.Console.ANSI
import System.Directory
import System.Environment
import System.Exit
import System.FilePath
import System.IO
import System.Process

main :: IO ()
main = do
  args <- getArgs
  case args of
    "haskell" : "grad" : _ -> run True "haskell"
    "haskell" : _ -> run False "haskell"
    "java" : "grad" : _ -> run True "java"
    "java" : _ -> run False "java"
    _ -> die "tester: bad arguments\nusage: tester <haskell | java> [grad]"

toTestProcess :: String -> String -> IO CreateProcess
toTestProcess haskellJava sourceFile = do
  wd <- getCurrentDirectory
  return $
    CreateProcess
      { cmdspec =
          RawCommand
            ( if haskellJava == "java"
                then "java"
                else takeDirectory wd </> haskellJava </> "icpp"
            )
            (["Main" | haskellJava == "java"] ++ [wd </> sourceFile]),
        cwd = Just (takeDirectory wd </> haskellJava),
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

run :: Bool -> String -> IO ()
run testGrad haskellJava =
  do
    good <-
      map (ExitSuccess,) . sortOn ((read :: String -> Int) . takeWhile isDigit . takeFileName . fst)
        <$> ( (++) <$> (map ((,5) . ("good" </>)) . filter (isSuffixOf ".cc") <$> listDirectory "good")
                <*> if testGrad then map ((,3) . ("grad" </>) . ("good" </>)) . filter (isSuffixOf ".cc") <$> listDirectory ("grad" </> "good") else pure []
            )
    bad <-
      map (ExitFailure 2,) . sortOn ((read :: String -> Int) . takeWhile isDigit . takeFileName . fst)
        <$> (map ((,5) . ("bad" </>)) . filter (isSuffixOf ".cc") <$> listDirectory "bad")
    let total = sum $ map (snd . snd) (bad ++ good)
    score <- foldM (\s (expect, (fp, worth)) -> toTestProcess haskellJava fp >>= \p -> runFile total p s (expect, (fp, worth))) 0 (good ++ bad)
    putStrLn ""
    setSGR [SetColor Foreground Vivid Blue]
    putStrLn $ "testing complete, final (tentative) score: " ++ show score ++ "/" ++ show total
    setSGR [Reset]

runFile :: Int -> CreateProcess -> Int -> (ExitCode, (FilePath, Int)) -> IO Int
runFile total process score (expect, (filename, worth)) =
  do
    putStrLn $ "interpreting file: " ++ filename ++ " ... "
    input <- readFile (filename ++ ".in")
    source <- readFile filename
    (Just stdin, Just stdout, Just stderr, ph) <- createProcess process
    hPutStr stdin input
    exitCode <- waitForProcess ph
    output <- hGetContents stdout
    err <- hGetContents stderr
    outputGolden <- readFile (filename ++ ".out")
    if not $ exitCode `matches` expect
      then do
        setSGR [SetColor Foreground Vivid Red]
        print exitCode
        print expect
        putStrLn $ "test failed! score: " ++ show score ++ "/" ++ show total
        setSGR [Reset]
        putStrLn $ "    expected interpreter to " ++ (if expect == ExitSuccess then "succeed, but it failed!" else "fail, but it succeeded!")
        putStrLn "    interpreter standard output:"
        putStrLn (unlines . map ("    " ++) $ lines output)
        putStrLn "    interpreter standard error:"
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
                putStrLn "    interpreter standard output:"
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
