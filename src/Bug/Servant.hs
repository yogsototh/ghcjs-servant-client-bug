{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeOperators         #-}

module Bug.Servant where

import           Data.Aeson (ToJSON(..),FromJSON(..),Value(..))
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Text                  as T
import           Data.Time.Calendar (Day,fromGregorian)
import           GHC.Generics (Generic)
import           Servant.API


--------------------------------------------------------------------------------
-- First test form
--------------------------------------------------------------------------------
data MyForm = MyForm {
  _id :: T.Text
  , _name :: T.Text
  , _pdfName :: T.Text
  } deriving (Generic,Show)

instance ToJSON MyForm
instance FromJSON MyForm

defaultForm :: MyForm
defaultForm = MyForm { _id = "id"
                     , _name = "name"
                     , _pdfName = "pdfName"}

type MyFormAPI = "procedure" :> "test" :> QueryParam "name" T.Text
                                       :> QueryParam "pdf" T.Text
                                       :> Post '[JSON] MyForm
            :<|> "procedure" :> "test" :> Capture "id" T.Text
                                       :> Get '[JSON] MyForm

type ServiceAPI = MyFormAPI
