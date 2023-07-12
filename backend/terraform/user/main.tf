module "UserCreate" {
  source = "../modules/lambda"
  function_name    = "UserCreate"
  handler          = "UserCreate.handler"
  source_code_hash = filebase64sha256("../lambdas/user/create/lambda.zip")
  # other necessary variables
}

module "UserGet" {
  source = "../modules/lambda"
  function_name    = "UserGet"
  handler          = "UserGet.handler"
  source_code_hash = filebase64sha256("../lambdas/user/get/lambda.zip")
  # other necessary variables
}
