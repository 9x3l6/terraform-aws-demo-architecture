variable "server_instance_ids" {
  description = "Comma separated string on instance ids to start/stop"
}

# lambda function archive file
variable "archive_file_source_dir" {
  description = "Directory where lambda source code is located"
  default = "code/"
}
variable "archive_file_output_path" {
  description = "Output path to zip file"
  default = "code.zip"
}

variable "lambda_function_runtime" {
  description = "Lambda function runtime"
  default = "python3.8"
}
variable "lambda_function_handler" {
  description = "Lambda function handler"
  default = "index.lambda_handler"
}