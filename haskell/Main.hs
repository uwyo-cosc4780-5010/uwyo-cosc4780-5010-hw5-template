{-# LANGUAGE LambdaCase #-}
module Main where

import ParCPP (myLexer, pProgram)
import System.Exit
import System.Environment

data RunLevel 
  = Typecheck
  | Interpret

main :: IO ()
main = do
  getArgs >>= \case
    (source:_) -> do
      code <- readFile source
      case pProgram (myLexer source) of
        Left err -> do
          putStrLn "SYNTAX ERROR"
          putStrLn err
          exitFailure
        Right tree -> undefined -- add type checker and interpreter here!
    _ -> do putStrLn "icpp: expected source file as argument"
            exitFailure
