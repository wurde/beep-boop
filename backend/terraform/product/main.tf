module "ProductList" {
  source = "../modules/lambda"
  function_name    = "ProductList"
  handler          = "ProductList.handler"
  source_code_hash = filebase64sha256("../lambdas/product/list/lambda.zip")
  # other necessary variables
}

module "ProductGet" {
  source = "../modules/lambda"
  function_name    = "ProductGet"
  handler          = "ProductGet.handler"
  source_code_hash = filebase64sha256("../lambdas/product/get/lambda.zip")
  # other necessary variables
}
