module Main where
import System.Environment
import System.Exit
import System.Process
import System.Directory
import Data.List
import Data.Char
import System.FilePath
import System.Console.ANSI
import System.IO
import Control.Monad (foldM)

main :: IO ()
main = do
  args <- getArgs
  case args of
    "haskell":_ -> toTestProcess "haskell" >>= run
    "java":_ -> toTestProcess "java" >>= run
    _ -> die "tester: bad arguments\nusage: tester <haskell | java>"

toTestProcess :: String -> IO CreateProcess
toTestProcess s = do
  wd <- getCurrentDirectory 
  return $ CreateProcess { cmdspec = ShellCommand "make compile",
                            cwd = Just (takeDirectory wd </> s),
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
                            use_process_jobs = False }

run :: CreateProcess  -> IO ()
run p = do
  good <- map ((,) ExitSuccess . ("good" </>)) . sortOn ((read :: String -> Int) . takeWhile isDigit) <$> listDirectory "good"
  bad <-  map ((,) (ExitFailure 2) . ("bad" </>))  . sortOn ((read :: String -> Int) . takeWhile isDigit) <$> listDirectory "bad"
  score <- foldM (runFile p) 0 (good ++ bad)
  putStrLn ""
  setSGR [SetColor Foreground Vivid Blue]
  putStrLn $ "testing complete, final (tentative) score: " ++ show score ++ "/80"
  setSGR [Reset]

runFile :: CreateProcess -> Int -> (ExitCode,FilePath) -> IO Int
runFile process score (expect,filename) = do
  putStrLn $ "typchecking file: " ++ filename ++ " ... "
  source <- readFile filename
  (Just stdin, Just stdout, Just stderr, ph) <- createProcess process
  hPutStr stdin source
  exitCode <- waitForProcess ph
  output <- hGetContents stdout
  if exitCode `matches` expect then do
    setSGR [SetColor Foreground Dull Green]
    putStrLn $ "typecheck success! score: " ++ show (score + 2) ++ "/80"
    setSGR [Reset]
    return $ score + 2
  else do
    setSGR [SetColor Foreground Vivid Red]
    putStrLn $ "typecheck failure! score: " ++ show score ++ "/80"
    setSGR [Reset]
    putStrLn $ "    expected typechecking to " ++ (if expect == ExitSuccess then "pass, but it failed!" else "fail, but it passed!")
    putStrLn "    source program:" 
    putStrLn (unlines . map ("    " ++) $ lines source)
    putStrLn "    typechecker standard output:"
    putStrLn (unlines . map ("    " ++) $ lines output) 
    return score

matches :: ExitCode -> ExitCode -> Bool
matches ExitSuccess     ExitSuccess     = True
matches (ExitFailure _) (ExitFailure _) = True
matches _               _               = False
