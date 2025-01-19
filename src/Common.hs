module Common where
import Data.Char (isUpper)

capitalised :: String -> Bool
capitalised name = isUpper (head name) 