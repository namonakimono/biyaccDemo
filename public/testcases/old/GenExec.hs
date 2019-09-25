module GenExec where

import System.Process
import System.Environment
import System.Info
import Text.Show.Pretty

testCases =
  [("expr/expr.txt", "ByExpr")
  ,("tigerUnambiguous/tiger.txt", "ByTigerUnambi")
  ,("exprKleene/kleene.txt", "ByExprKleene")
  ,("exprNonlinear/nonlinear.txt", "ByExprNonlinear")
  ,("exprAdapt/adapt.txt", "ByExprAdapt")
  ,("exprAmbi/exprAmbi.txt", "ByExprAmbi")
  -- ,("tigerUnambiKleene/tigerUnambiKleene.txt", "ByTigerUnambiKleene")
  ]

genExec :: (String,String) -> IO ()
genExec (inFile, outFile) = do
  readProcess "biyacc" [inFile, outFile] ""
  return ()

genExecs = mapM_ genExec testCases


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

