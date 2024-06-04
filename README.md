# Weather App - Infrastructure and Setup

WeatherApp is a simple weather forecast application. Although the core code of the weather application remains almost unchanged, this project demonstrates the addition of various infrastructure components to ensure a robust and maintainable implementation.

![image](https://github.com/HubertZgola/weatherapp/assets/99662754/6f02e81f-e666-475b-bfc0-d8d34ff7c9cd)

## What has been done?

1. Created a personal repository in Github.
2. The application uses OpenWeatherMap API key to receive weather data.
3. Created Dockerfiles for frontend and backend of application.
4. Created docker-compose.yml.
5. Added library for creating environment variables.
6. Created Ansible Playbooks to run an app in the cloud and locally.
7. Automatically generated SSL certificate using Certbot.
8. A reverse proxy has been set up to balance loads.
9. Automatically added id_rsa_internship.pub to authorized_keys.
10. Created terraform files to automate the creation of Azure cloud resources.

## How to run the application?

### Run Locally

1. Clone the repository and navigate to the project directory.
2. Install Ansible.
3. Run command:
   ```
    ansible-playbook playbook_local.yml
   ```
4. After launching the playbook, enter your API key.
5. In your web browser, navigate to:
   ```
    localhost:8000
   ```
   
### Run in MS Azure Cloud
To run the application in MS Azure Cloud, navigate to:
https://weatherapp-hz.westeurope.cloudapp.azure.com/.


## How to deploy the application using Terraform files and Ansible?

1. Clone the repository and navigate to the project directory.
2. Complete the file terraform.tfvars using your Azur data.
3. Set your values ​​for Azure resources
4. Use command to initialize config:
```
terraform init
```
5. Use command to check your selected options:
```
terraform plan
```
6. Use the command to deploy Azure resources with VM:
```
terraform apply
```
7. Connect with VM using ssh:
```
ssh name_of_user@your_domain_name

ssh weatherapp-hz@weatherapp-hz.westeurope.cloudapp.azure.com
```
8. If it works in the second terminal of your working directory, run:
```
ansible-playbook -i Inventory playbook_azure.yml
```
9.  After launching the playbook, enter your API key, email to make SSL certificate and domain_name.
10. In your web browser, navigate to:
```
https://your_domain_name.com

https://weatherapp-hz.westeurope.cloudapp.azure.com/
```

### Possible Improvements
Testing:
* Automated unit tests: Implement unit tests for frontend and backend application code to ensure stability and correct operation.
* Integration tests: Create integration tests to verify the interactions between frontend and backend components and the correct operation of the entire application.

Functionality:
Additional forecast options: Extend the app to display additional weather information, such as:
* Weather forecast for a longer period (e.g. for a week or a month)
* Detailed weather data (e.g. atmospheric pressure, air humidity, wind speed)
* Weather alerts (e.g. warnings about storms, heat, frost)
* Location Selectability: Allow the user to manually enter the location for which they want to get the weather forecast.
* Search function: Implement a search function that will allow the user to quickly find the location of interest.

### Author
Thank you very much for the opportunity to participate in this project. This is a great honor and a valuable lesson for me. I will be happy to receive your feedback on my performance of the task.

Hubert Zgoła | hubert.zgola@gmail.com
