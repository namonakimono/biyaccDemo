{-# LANGUAGE DeriveGeneric #-}
module Xbel where

import Data.Map (Map(..))
import qualified Data.Map as Map
import Text.XML.HaXml.XmlContent hiding (List1)
import Text.XML.HaXml.Types
import Text.XML.PutXML.DTD.HaXml.TypeDef
import Text.XML.PutXML.DTD.Type
import Text.XML.HaXml.DtdToHaskell.TypeDef (Name(..))
import Control.Monad
import GHC.Generics as Generics

type EMPTY = ()


data Xbel = Xbel Xbel.Title [(Either Xbel.Bookmark Xbel.Folder)]
          deriving (Eq,Show,Generic)
newtype Title = Title Str 		deriving (Eq,Show,Generic)
data Bookmark = Bookmark Bookmark_Attrs Xbel.Title
              deriving (Eq,Show,Generic)
data Bookmark_Attrs = Bookmark_Attrs
    { bookmarkHref :: Str
    } deriving (Eq,Show,Generic)
data Folder = Folder Xbel.Title
                     [(Either Xbel.Bookmark Xbel.Folder)]
            deriving (Eq,Show,Generic)
instance HTypeable Xbel.Xbel where
    toHType x = Defined "xbel" [] []
instance XmlContent Xbel.Xbel where
    toContents (Xbel.Xbel a b) =
        [CElem (Elem (N "xbel") [] (toContents a ++
                                    concatMap toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["xbel"]
        ; interior e $ return (Xbel.Xbel) `apply` parseContents
                       `apply` many parseContents
        } `adjustErr` ("in <xbel>, "++)
instance HTypeable Xbel.Title where
    toHType x = Defined "title" [] []
instance XmlContent Xbel.Title where
    toContents (Xbel.Title a) =
        [CElem (Elem (N "title") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["title"]
        ; interior e $ return (Xbel.Title)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <title>, "++)
instance HTypeable Xbel.Bookmark where
    toHType x = Defined "bookmark" [] []
instance XmlContent Xbel.Bookmark where
    toContents (Xbel.Bookmark as a) =
        [CElem (Elem (N "bookmark") (toAttrs as) (toContents a)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["bookmark"]
        ; interior e $ return (Xbel.Bookmark (fromAttrs as))
                       `apply` parseContents
        } `adjustErr` ("in <bookmark>, "++)
instance XmlAttributes Xbel.Bookmark_Attrs where
    fromAttrs as =
        Xbel.Bookmark_Attrs
          { Xbel.bookmarkHref = definiteA (\a b -> fmap Str $ fromAttrToStr a b) "bookmark" "href" as
          }
    toAttrs v = catMaybes 
        [ (\s x -> toAttrFrStr s (unStr x)) "href" (Xbel.bookmarkHref v)
        ]
instance HTypeable Xbel.Folder where
    toHType x = Defined "folder" [] []
instance XmlContent Xbel.Folder where
    toContents (Xbel.Folder a b) =
        [CElem (Elem (N "folder") [] (toContents a ++
                                      concatMap toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["folder"]
        ; interior e $ return (Xbel.Folder) `apply` parseContents
                       `apply` many parseContents
        } `adjustErr` ("in <folder>, "++)
instance Typeable Xbel.Xbel where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "xbel" "Xbel") typeof
instance Typeable Xbel.Title where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "title" "Title") typeof
instance Typeable Xbel.Bookmark where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "bookmark" "Bookmark") typeof
instance Typeable Xbel.Bookmark_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "Bookmark_Attrs") (Tag "@href" typeof)
instance Typeable Xbel.Folder where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "folder" "Folder") typeof

typeEnv = Map.insert "xbel" (DynT (typeof :: Type (Xbel.Xbel))) (Map.insert "title" (DynT (typeof :: Type (Xbel.Title))) (Map.insert "bookmark" (DynT (typeof :: Type (Xbel.Bookmark))) (Map.insert "folder" (DynT (typeof :: Type (Xbel.Folder))) (Map.empty))))
