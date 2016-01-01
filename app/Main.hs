{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE LambdaCase            #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE TypeOperators         #-}
{-# LANGUAGE UnicodeSyntax         #-}

{-| This module ties in the business logic with the servant type to implement a server.
    It reads a bit of configuration to show how to parameterize things
-}

module Main where

import           Control.Monad.Trans.Except (ExceptT,throwE)
import Data.Monoid ((<>))
import qualified Data.Text                  as T
import           Network.Wai (Application)
import           Network.Wai.Handler.Warp (run)
import           System.Environment (getEnvironment)

import           Servant
import           Bug.Servant

--------------------------------------------------------------------------------
-- Minimal MyForm Serve
--------------------------------------------------------------------------------
makeId :: T.Text -> T.Text -> T.Text
makeId l r = l <> "-" <> r

assertQueryParam :: Monad m => String -> Maybe a -> ExceptT ServantErr m a
assertQueryParam paramName =
  maybe (throwE (err400 {errReasonPhrase = "use " ++ paramName ++ " parameter please."}))
        return

newMyForm :: Maybe T.Text -> Maybe T.Text -> ExceptT ServantErr IO MyForm
newMyForm mName mPdfName = do
  name <- assertQueryParam "name" mName
  pdf <- assertQueryParam "pdf" mPdfName
  return (defaultForm { _name = name
                      , _pdfName = pdf
                      , _id = makeId name pdf
                      })

getMyForm :: T.Text -> ExceptT ServantErr IO MyForm
getMyForm ident = return (defaultForm {_id = ident})
--------------------------------------------------------------------------------


-- our full server has an extended interface with both some normal route and a entire servant API
type TopLevelServer  = "api" :> ServiceAPI
                    :<|> Raw

serverAPI :: Server ServiceAPI
serverAPI = newMyForm :<|> getMyForm

-- the complete server serves both part reusing the
serverTopLevel :: Server TopLevelServer
serverTopLevel = serverAPI :<|> serveDirectory "ui/assets/"

topLevelServer :: Proxy TopLevelServer
topLevelServer = Proxy

-- we have a WAI application whose behaviour depends on 2 parameters
app :: Application
app = serve topLevelServer serverTopLevel

main :: IO ()
main = do
  env <- getEnvironment
  let port = maybe 8080 read $ lookup "PORT" env
  putStrLn ("running on " ++ show port)
  run port app
