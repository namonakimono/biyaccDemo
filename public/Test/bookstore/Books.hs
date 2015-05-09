{-# LANGUAGE DeriveGeneric #-}
module Books where

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


newtype Books = Books [Books.Book] 		deriving (Eq,Show,Generic)
data Book = Book Books.Title Books.Price
          deriving (Eq,Show,Generic)
newtype Title = Title Str 		deriving (Eq,Show,Generic)
newtype Price = Price Str 		deriving (Eq,Show,Generic)
instance HTypeable Books.Books where
    toHType x = Defined "books" [] []
instance XmlContent Books.Books where
    toContents (Books.Books a) =
        [CElem (Elem (N "books") [] (concatMap toContents a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["books"]
        ; interior e $ return (Books.Books) `apply` many parseContents
        } `adjustErr` ("in <books>, "++)
instance HTypeable Books.Book where
    toHType x = Defined "book" [] []
instance XmlContent Books.Book where
    toContents (Books.Book a b) =
        [CElem (Elem (N "book") [] (toContents a ++ toContents b)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["book"]
        ; interior e $ return (Books.Book) `apply` parseContents
                       `apply` parseContents
        } `adjustErr` ("in <book>, "++)
instance HTypeable Books.Title where
    toHType x = Defined "title" [] []
instance XmlContent Books.Title where
    toContents (Books.Title a) =
        [CElem (Elem (N "title") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["title"]
        ; interior e $ return (Books.Title)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <title>, "++)
instance HTypeable Books.Price where
    toHType x = Defined "price" [] []
instance XmlContent Books.Price where
    toContents (Books.Price a) =
        [CElem (Elem (N "price") [] ((toText . unStr) a)) ()]
    parseContents = do
        { e@(Elem _ [] _) <- element ["price"]
        ; interior e $ return (Books.Price)
                       `apply` (liftM Str text `onFail` return (Str ""))
        } `adjustErr` ("in <price>, "++)
instance Typeable Books.Books where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "books" "Books") typeof
instance Typeable Books.Book where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "book" "Book") typeof
instance Typeable Books.Title where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "title" "Title") typeof
instance Typeable Books.Price where
    typeof = Data (Text.XML.HaXml.DtdToHaskell.TypeDef.Name "price" "Price") typeof

typeEnv = Map.insert "books" (DynT (typeof :: Type (Books.Books))) (Map.insert "book" (DynT (typeof :: Type (Books.Book))) (Map.insert "title" (DynT (typeof :: Type (Books.Title))) (Map.insert "price" (DynT (typeof :: Type (Books.Price))) (Map.empty))))
