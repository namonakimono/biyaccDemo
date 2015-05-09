{-# LANGUAGE DeriveGeneric #-}
module Bookstore where

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


newtype Bookstore = Bookstore [Bookstore.Book] 		deriving (Eq,Show,Generic)
data Book = Book Book_Attrs Bookstore.Title
                 (List1 Bookstore.Author) Bookstore.Year Bookstore.Price
          deriving (Eq,Show,Generic)
data Book_Attrs = Book_Attrs
    { bookCategory :: (Mb Str)
    } deriving (Eq,Show,Generic)
newtype Title = Title Str 		deriving (Eq,Show,Generic)
newtype Author = Author Str 		deriving (Eq,Show,Generic)
newtype Year = Year Str 		deriving (Eq,Show,Generic)
newtype Price = Price Str 		deriving (Eq,Show,Generic)
instance HTypeable Bookstore.Bookstore where
    toHType x = Defined "bookstore" [] []
instance XmlContent Bookstore.Bookstore where
    toContents (Bookstore.Bookstore a) =
        [CElem (Elem (N "bookstore") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["bookstore"]
        ; interior e $ return (Bookstore.Bookstore)
                       `apply` many parseContents
        } `adjustErr` ("in <bookstore>, "++)
instance HTypeable Bookstore.Book where
    toHType x = Defined "book" [] []
instance XmlContent Bookstore.Book where
    toContents (Bookstore.Book as a b c d) =
        [CElem (Elem (N "book") (toAttrs as) (toContents a ++ toContents b
                                              ++ toContents c ++ toContents d)) ()]
    parseContents = do
        { e@(Elem _ as _) <- element ["book"]
        ; interior e $ return (Bookstore.Book (fromAttrs as))
                       `apply` parseContents `apply` parseContents `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <book>, "++)
instance XmlAttributes Bookstore.Book_Attrs where
    fromAttrs as =
        Bookstore.Book_Attrs
          { Bookstore.bookCategory = possibleMbA (\a b -> fmap Str $ fromAttrToStr a b) "category" as
          }
    toAttrs v = catMaybes 
        [ mbToAttr (\s x -> toAttrFrStr s (unStr x)) "category" (Bookstore.bookCategory v)
        ]
instance HTypeable Bookstore.Title where
    toHType x = Defined "title" [] []
instance XmlContent Bookstore.Title where
    toContents (Bookstore.Title a) =
        [CElem (Elem (N "title") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["title"]
        ; interior e $ return (Bookstore.Title)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <title>, "++)
instance HTypeable Bookstore.Author where
    toHType x = Defined "author" [] []
instance XmlContent Bookstore.Author where
    toContents (Bookstore.Author a) =
        [CElem (Elem (N "author") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["author"]
        ; interior e $ return (Bookstore.Author)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <author>, "++)
instance HTypeable Bookstore.Year where
    toHType x = Defined "year" [] []
instance XmlContent Bookstore.Year where
    toContents (Bookstore.Year a) =
        [CElem (Elem (N "year") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["year"]
        ; interior e $ return (Bookstore.Year)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <year>, "++)
instance HTypeable Bookstore.Price where
    toHType x = Defined "price" [] []
instance XmlContent Bookstore.Price where
    toContents (Bookstore.Price a) =
        [CElem (Elem (N "price") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["price"]
        ; interior e $ return (Bookstore.Price)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <price>, "++)
instance Typeable Bookstore.Bookstore where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "bookstore" "Bookstore") typeof
instance Typeable Bookstore.Book where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "book" "Book") typeof
instance Typeable Bookstore.Book_Attrs where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "@" "Book_Attrs") (Either One (Tag "@category" typeof))
instance Typeable Bookstore.Title where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "title" "Title") typeof
instance Typeable Bookstore.Author where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "author" "Author") typeof
instance Typeable Bookstore.Year where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "year" "Year") typeof
instance Typeable Bookstore.Price where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "price" "Price") typeof

typeEnv = Map.insert "bookstore" (DynT (typeof :: Type (Bookstore.Bookstore))) (Map.insert "book" (DynT (typeof :: Type (Bookstore.Book))) (Map.insert "title" (DynT (typeof :: Type (Bookstore.Title))) (Map.insert "author" (DynT (typeof :: Type (Bookstore.Author))) (Map.insert "year" (DynT (typeof :: Type (Bookstore.Year))) (Map.insert "price" (DynT (typeof :: Type (Bookstore.Price))) (Map.empty))))))
