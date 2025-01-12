import Par
import Abs
import ErrM

import Prelude
import qualified TypeChecker
import qualified LLVM

import System.Environment (getArgs)
import qualified Data.Map as Map
import Control.Monad.State
import System.FilePath (replaceExtension)
import System.Process (callCommand)


getProgram :: String -> Program
getProgram programStr =
    let res = pProgram (myLexer programStr) in
    case res of
        Ok program -> program
        Bad s -> error ("ERROR\n" ++ s)

assertArgs :: [String] -> IO ()
assertArgs args = do
    if length args /= 1
        then error "Usage: insc_jvm <file>"
        else return ()


main :: IO ()
main = do
    args <- getArgs
    assertArgs args
    let filePath = head args
    codeStr <- readFile filePath
    let program = getProgram codeStr
    functions <- readFile "lib/functions.ll"
    -- TypeChecker.comp program
    let llFilename = replaceExtension filePath ".ll"
    let bcFilename = replaceExtension filePath ".bc"
    let programStr = functions ++ LLVM.comp program
    writeFile llFilename programStr
    callCommand $ "llvm-as " ++ llFilename ++ " -o " ++ bcFilename

    -- let filename = takeFileName filePath
    -- let jasminFilename = replaceExtension filePath ".j"
    -- let fileDir = takeDirectory filePath
    -- let className = replaceExtension filename ""
    -- let result = compToStr className program
    -- writeFile jasminFilename result
    -- callCommand $ "java -jar lib/jasmin.jar " ++ jasminFilename ++ " -d " ++ fileDir
