{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE FlexibleContexts #-}

module Main where

import Data.Foldable (for_)
import System.Environment (getArgs)

import Interop.Java.IO
import Java

data Sequencer
  = Sequencer @javax.sound.midi.Sequencer
  deriving (Class, Show)

foreign import java unsafe "@static javax.sound.midi.MidiSystem.getSequencer" getSequencer
  :: Java a Sequencer

foreign import java unsafe "@interface open" openSequencer
  :: Java Sequencer ()

foreign import java unsafe "@interface" setSequence
  :: (a <: InputStream) => a -> Java Sequencer ()

foreign import java unsafe "@interface start" startSequencer
  :: Java Sequencer ()

foreign import java unsafe "@interface stop" stopSequencer
  :: Java Sequencer ()

data FileInputStream
  = FileInputStream @java.io.FileInputStream
  deriving (Class, Show)

type instance Inherits FileInputStream = '[InputStream, Closeable]

foreign import java unsafe "@new" newFileInputStream
  :: File -> Java a FileInputStream

main :: IO ()
main = do
  args <- getArgs
  java $ for_ args $ \a -> do
    s <- getSequencer
    s <.> openSequencer
    is <- newFileInputStream =<< newFile a
    s <.> setSequence is
    s <.> startSequencer
