{-# LANGUAGE OverloadedStrings #-}

-- | The division between a view and a component is arbitrary, but for me components are pieces that
-- are re-used many times for different purposes.  In the TODO app, there is one component for the
-- text box.
module Client where

import Bug.Servant

import Data.Proxy
import Servant.API
import Servant.Client
import qualified Data.Text as T
import Control.Monad.Trans.Except (ExceptT)
import qualified Network.HTTP.Client as C

import System.IO.Unsafe (unsafePerformIO)

myApi :: Proxy ServiceAPI
myApi = Proxy

postProcedureTest :: Maybe T.Text -> Maybe T.Text -> ExceptT ServantError IO MyForm
getProcedureTest :: T.Text -> ExceptT ServantError IO MyForm
(postProcedureTest :<|>
 getProcedureTest) = client myApi host manager
   where host = BaseUrl Http "localhost" 8080 "/api"
         manager = unsafePerformIO $ C.newManager C.defaultManagerSettings
