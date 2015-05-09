module Main where

import Data.Map (Map(..))
import qualified Data.Map as Map
import Text.XML.HaXml.XmlContent hiding (List,List1,String)
import Text.XML.HaXml.Types
import Text.XML.PutXML.DTD.HaXml.TypeDef
import Text.XML.PutXML.DTD.Type
import Text.XML.HaXml.DtdToHaskell.TypeDef (Name(..))
import Control.Monad
import UI.PutXML.LensMenu
import Generics.Putlenses.Putlens
import Text.XML.PutXML.DTD.Type
import Text.XML.PutXML.Update.AST
import Text.XML.PutXML.Update.UpdateToCore
import Text.XML.PutXML.Update.CoreToLenses
import Text.XML.HaXml.DtdToHaskell.TypeDef hiding (ppTypeDef,mangle,List,Any,String)
import Text.XML.HaXml.ShowXmlLazy
import Text.XML.HaXml.Namespaces
import Text.XML.HaXml.DtdToHaskell.Convert
import Text.XML.PutXML.XQuery.UXQ
import Text.XML.PutXML.XPath.HXT.XPathDataTypes
import Text.XML.HXT.DOM.QualifiedName


import Bookstore
import Books



typeEnv = Map.union (Map.mapKeys ("s:"++) Bookstore.typeEnv) (Map.union (Map.mapKeys ("v:"++) Books.typeEnv) (Map.empty))

sourceType = (typeof :: Type Bookstore.Bookstore)
viewType = (typeof :: Type Books.Books)

ast = Program [Import "bookstore.dtd" "s",Import "books.dtd" "v"] [VarBind "source" "s.xml",VarBind "view" "v.xml"] (Start "updateBookStore" [XQPath (CPathSlash (CPathVar "source") (CPathSlash (CPathSlash CPathSelf CPathChild) (CPathNodeTest (NameTest (mkName "bookstore"))))),XQPath (CPathSlash (CPathVar "view") (CPathSlash (CPathSlash CPathSelf CPathChild) (CPathNodeTest (NameTest (mkName "books")))))]) [ProcedureDecl (Procedure "updateBookStore" [(ProcSVar "source",NameT "s:bookstore"),(ProcVVar "view",NameT "v:books")] [StmtUpd (UpdateView (Just (VarPat (VarV "book"))) (CPathSlash (CPathVar "source") (CPathSlash (CPathSlash CPathSelf CPathChild) (CPathNodeTest (NameTest (mkName "book"))))) [ViewStmtMatch [StmtUpd (SingleReplace Nothing (CPathSlash (CPathSlash CPathSelf CPathChild) (CPathNodeTest (NameTest (mkName "price")))) (XQPath (CPathVar "price"))) []],ViewStmtUMV [StmtUpd (UpdateCreate (XQElem "book" (XQProd (XQAttr "category" (XQPath (CPathString "undefined"))) (XQProd (XQProd (XQProd (XQElem "title" XQEmpty) (XQElem "author" (XQPath (CPathString "??")))) (XQElem "year" (XQPath (CPathString "??")))) (XQElem "price" XQEmpty))))) []]] (Just (ElementPat "book" [VarPat (VarT "title" (NameT "v:title")),VarPat (VarT "price" (NameT "v:price"))])) (CPathSlash (CPathVar "view") (CPathSlash CPathChild (CPathNodeTest (TypeTest XPNode)))) (Just (MatchSV (CPathSlash (CPathVar "book") (CPathSlash (CPathSlash CPathSelf CPathChild) (CPathNodeTest (NameTest (mkName "title"))))) (CPathVar "title")))) []])]

main = lensmenu sourceType viewType Main.typeEnv ast
