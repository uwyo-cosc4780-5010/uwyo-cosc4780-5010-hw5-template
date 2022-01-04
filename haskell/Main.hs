module Main where

import ParCPP ( pProgram, myLexer )

main :: IO ()
main = do
  c <- getContents
  case pProgram (myLexer c) of
    Left err -> putStrLn "parse error!" >> putStrLn err
    Right tree -> undefined -- successful parse! typecheck here
