{-# LANGUAGE QuasiQuotes #-}
module Maestro.Test.Transaction where

import           Data.Aeson           (decode, eitherDecode)
import           Test.Hspec
import           Text.RawString.QQ

import           Data.ByteString.Lazy (ByteString)
import           Maestro.Types

spec_pool :: Spec
spec_pool = do
  it "parsing /transaction/tx_hash/cbor sample" $ do
    eitherDecode txCborSample
    `shouldBe`
    Right txCborExpected

  it "parsing /transaction/tx_hash/outputs/index/address sample" $ do
    eitherDecode txAddressSample
    `shouldBe`
    Right txAddressExpected

txCborSample :: ByteString
txCborSample = [r|
  {
    "cbor": "84a4008382582038dc2ac77bac948bdc623be..."
  }
|]

txCborExpected :: TxCbor
txCborExpected =  TxCbor{ _txCbor = "84a4008382582038dc2ac77bac948bdc623be..."}


txAddressSample :: ByteString
txAddressSample = [r|
  {
    "address": "addr1wxgg25t3tk30jqzl2elqz94lzgmr8a9c9m5z902ds5sjh0g7uaj8z"
  }
|]

txAddressExpected :: TxAddress
txAddressExpected = TxAddress {_txAddress = "addr1wxgg25t3tk30jqzl2elqz94lzgmr8a9c9m5z902ds5sjh0g7uaj8z"}

txUtxoSample  :: ByteString
txUtxoSample  = [r|
  {
    "tx_hash": "9907c1bcab96889368d975ec1964e2fedfef22ce4a0e367bf9cb621b9f0dcb4a",
    "index": 0,
    "assets": [
      {
        "unit": "lovelace",
        "quantity": 7280082022
      },
      {
        "unit": "34250edd1e9836f5378702fbf9416b709bc140e04f668cc355208518#4154414441636f696e",
        "quantity": 10824
      }
    ],
    "address": "addr_test1vpfwv0ezc5g8a4mkku8hhy3y3vp92t7s3ul8g778g5yegsgalc6gc",
    "datum": {
      "type": "inline",
      "hash": "432cb73420839fb517533c365d7ec125c457ea4ba5c0349be81be6796d52ef3b",
      "bytes": "1a00278530",
      "json": {
        "int": 2590000
      }
    },
    "reference_script": {
      "type": "plutusv2",
      "hash": "3a888d65f16790950a72daee1f63aa05add6d268434107cfa5b67712",
      "bytes": "480100002221200101",
      "json": null
    }
  }
|]

txUtxoExpected :: Utxo
txUtxoExpected  =
  Utxo
    {_utxoTxHash = ""
    , _utxoIndex  = 0
    , _utxoAssets =
        [
          MaestroAsset
            { _maestroAssetUnit = Just "lovelace"
            , _maestroAssetQuantity = 7280082022
            , _maestroAssetName = Nothing
            }
          ,
          MaestroAsset
            { _maestroAssetUnit = Just "34250edd1e9836f5378702fbf9416b709bc140e04f668cc355208518#4154414441636f696e"
            , _maestroAssetQuantity = 10824
            , _maestroAssetName = Nothing
            }
        ]
    , _utxoAddress = "addr_test1vpfwv0ezc5g8a4mkku8hhy3y3vp92t7s3ul8g778g5yegsgalc6gc"
    , _utxoDatum  =
        Just MaestroDatum
          { _datumType  = Inline
          , _datumHash  = "432cb73420839fb517533c365d7ec125c457ea4ba5c0349be81be6796d52ef3b"
          , _datumBytes = Just "1a00278530"
          , _datumJson  = decode $ "{\"int\":2590000}"
          }

    , _utxoReferenceScript  =
        Just ReferenceScript
        { _refScriptHash  = "3a888d65f16790950a72daee1f63aa05add6d268434107cfa5b67712"
        , _refScriptBytes = Just "480100002221200101"
        , _refScriptType  = Plutusv2
        , _refScriptJson  = Nothing
        }
    }
