module GenExec where

import System.Process
import System.Environment
import System.Info
import Text.Show.Pretty

testCases =
  [("expr/expr.txt", "ByExpr")
  ,("tiger/tiger.txt", "ByTiger")
  ,("exprAmb/exprAmb.txt", "ByExprAmb")
  ,("tigerAmb/tigerAmb.txt", "ByTigerAmb")
  ]

genExecs = mapM_ genExec testCases

genExec :: (String,String) -> IO ()
genExec (inFile, outFile) = do
  readProcess "biyacc" [inFile, outFile] ""
  return ()

getFileHash :: String -> IO (String,String)
getFileHash byFile = do
  md5_ <- case os of
            "darwin" -> readProcess "md5" ["-q", byFile] ""
            "linux"  -> readCreateProcess (shell $ "md5sum " ++ byFile ++ " | awk '{print $1}'") ""

  -- The output has an additional newline. Drop it.
  return (byFile, init md5_)

showFilesHashes :: IO ()
showFilesHashes = do
  res <- mapM getFileHash (map fst testCases)
  putStrLn $ ppShow res

main = genExecs
