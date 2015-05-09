{-# LANGUAGE DeriveGeneric, TemplateHaskell #-}

module DBLP where
	
import Generics.Putlenses.Language
import Generics.Putlenses.TH
import Generics.Putlenses.Putlens
import GHC.Generics
import GHC.InOut
import Generics.Putlenses.Examples.Examples
import Data.List

data DBLP = DBLP [Inproceedings] [Person] [Author] [Cite] deriving (Eq,Show,Generic)
data Inproceedings = Inproceedings Key Title Year deriving (Eq,Show,Generic)
data Person = Person Pid Name deriving (Eq,Show,Generic)
data Author = Author Key Pid deriving (Eq,Show,Generic)
data Cite = Cite Key Citation deriving (Eq,Show,Generic)
type Key = Int
type Title = String
type Year = Int
type Pid = Int
type Citation = Key
type Name = String

$( makePutlensConstructors ''DBLP)
$( makePutlensConstructors ''Inproceedings)
$( makePutlensConstructors ''Person)
$( makePutlensConstructors ''Author)
$( makePutlensConstructors ''Cite)

data DBLP' = DBLP' [Inproceedings'] deriving (Eq,Show,Generic)
data Inproceedings' = Inproceedings' Title' Year' [Author'] [Cite'] deriving (Eq,Show,Generic)
type Author' = String
type Cite' = String
type Title' = String
type Year' = Int

$( makePutlensConstructors ''DBLP')
$( makePutlensConstructors ''Inproceedings')

getInproceedingsKey :: Inproceedings -> Key
getInproceedingsKey (Inproceedings k t y) = k
getInproceedingsTitle :: Inproceedings -> Title
getInproceedingsTitle (Inproceedings k t y) = t

dblpPut :: Putlens st e DBLP DBLP'
dblpPut = restPut .< papersPut .< undBLP'Put

restPut :: Putlens st e DBLP [(Inproceedings,([Author'],[Cite']))]
restPut = dBLPPut .< assoclPut .< restPut'

type Rest = ([Person],([Author],[Cite]))
type Rest2 = ([Inproceedings],Rest)

restPut' :: Putlens st e ([Inproceedings],Rest) [(Inproceedings,([Author'],[Cite']))]
restPut' = unforkPut l r .< unzipPut
    where l = keepsndPut
          r = remfstPut fst .< restPut''
          unzipPut = customPut (\st s -> unzip) (uncurry zip)

restPut'' :: Putlens st e ([Inproceedings],Rest2) [([Author'],[Cite'])]
restPut'' = (innPut ><< idPut) .< undistlPut .< (empty -|-< unforkPut l r) .< outPut
    where empty = keepsndPut
          l = (keepsndPut ><< idPut) .< paperRefsPut
          r = (keepfstPut ><< idPut) .< restPut''

paperRefsPut :: Putlens st e (Inproceedings,Rest2) ([Author'],[Cite'])
paperRefsPut = unforkPut l r
    where l = (idPut ><< ) .< peopleauthorsPut 
          r = 

peopleauthorsPut :: Putlens st e (Key,([Person],[Author])) [Author']
peopleauthorsPut = undefined

citesPut :: Putlens st e ([Cite]) [Cite']
citesPut = undefined

papersPut :: Putlens st e [(Inproceedings,([Author'],[Cite']))] [Inproceedings']
papersPut = withS $ initSt (\st e v -> let ps = map fst e in (ps,highestKey ps,0)) (mapPut paperPut)
    where highestKey = maximum . map (fst . out)

paperPut :: Putlens ([Inproceedings],Key,Key) e (Inproceedings,([Author'],[Cite'])) Inproceedings'
paperPut = (inproceedingsPut .< modifySt makeKey (addfstPut keyOf) ><< idPut) .< uninproceedings'Put
    where keyOf (_,_,k) e v = k
          makeKey (ps,maxKey,_) e (title,year) = case find (\p -> getInproceedingsTitle p == title) ps of
              Just p -> (ps,maxKey,getInproceedingsKey p)
              otherwise -> let newKey = succ maxKey in (ps,newKey,newKey)


