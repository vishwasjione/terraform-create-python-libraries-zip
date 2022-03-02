// Creating a folder and installing lib in there

resource "null_resource" "lambda-layer" {
  
  triggers = {  
  requirements = filebase64sha256("requirements.txt")
  trigger_condition = 'provide any trigger condition you like based on the file"  
  }
 
provisoner "local-exec" {

  interpreter = ["/bin/sh","-c"]
  command = <<EOT
  echo "Installing dependent packages for lambda layer"
  echo "python3 --version"
  echo "creating new directory where lib/packages will be installed"
  mkdir -p project-name/pythonlib
  echo "pip installing required packages"
  python3 -m pip install -r requirements.txt --target project-name/pythonlib
  chmod -R 755 project-name/pythonlib
  EOT
}  
}

// creating zip file 

data "archive_file" "lambda-layer-zip" {

type = "zip"
source_dir = "project-name/pythonlib"
output_path = "project-name/zip_python.zip"
depends_on = [null_resource.lambda-layer]

}
