{-# LANGUAGE LambdaCase #-}
module Main where

import ParCPP
import System.Exit
import System.Environment

main :: IO ()
main = do
  getArgs >>= \case
    (file:_) -> do
      code <- readFile file
      case pProgram (myLexer code) of
        Left err -> do
          putStrLn "SYNTAX ERROR"
          putStrLn err
          exitFailure
        Right tree -> undefined -- type check and compile here!
