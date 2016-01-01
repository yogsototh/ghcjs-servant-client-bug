module Main where

import Control.Applicative ((<$>))
import Control.Monad.Trans (liftIO)
import GHCJS.DOM (enableInspector, webViewGetDomDocument, runWebGUI)
import GHCJS.DOM.Document (getBody, createElement)
import GHCJS.DOM.HTMLElement (setInnerText)
import GHCJS.DOM.Element (click)
import GHCJS.DOM.HTMLParagraphElement
       (castToHTMLParagraphElement)
import GHCJS.DOM.Node (appendChild)
import GHCJS.DOM.EventM (mouseClientXY,on)

import Client
import qualified Data.Text as T
import Control.Monad.Trans.Except

main = runWebGUI $ \ webView -> do
    enableInspector webView
    Just doc <- webViewGetDomDocument webView
    Just body <- getBody doc
    setInnerText body (Just "Open Console and click anywhere.")
    on body click $ do
        (x, y) <- mouseClientXY
        liftIO $ do
          putStrLn $ "Clicked at " ++ show (x,y)
          _ <- runExceptT $ postProcedureTest (Just (T.pack "yolo")) (Just (T.pack "ppp"))
          return ()
    return ()
