module Main where

import Prelude (String)
import Protolude hiding ((<>))
import Diagrams.Prelude
import Diagrams.Backend.SVG.CmdLine
import Presentation (sol3)

splitsAt :: Int -> [a] -> [[a]]
splitsAt n xs = case splitAt n xs of
  (ys, []) -> [ys]
  (ys, zs) -> ys:(splitsAt n zs)

columns :: [[String]]
columns = splitsAt 10 sol3

fizzBuzzGraphic :: Diagram B
fizzBuzzGraphic = hsep 1 (map (vsep 0.0 . (map (\s -> (topLeftText s # font "Hack" # translateY (-0.25)) <> (square 2 # alignTL # scaleX 2.5 # lw none)))) columns)

main :: IO ()
main = mainWith $ (square 2 # lw none) === fizzBuzzGraphic
