const inquirer = require('inquirer');
const {ServiceModel} = require('../../app/models/service.js');

inquirer.prompt([
    {
        type: 'confirm',
        name: 'confirm',
        message: 'Create a new Service?'
    },
    {
        type: 'input',
        name: 'serviceName',
        message: 'Please name the new Service',
        when: (answers) => answers.confirm,
        validate: (answers) => {
            return answers.length > 3 ? 
                true : 'The Service name must have more than 3 characters';
        }
    }
]).then((answers) => {
    if (answers.serviceName) {
        let service = new ServiceModel({name: answers.serviceName});
        let data = service.setPasswordData();
        console.log(`#####################################`)
        console.log(`Please save this data safely:`)
        console.log(`Data: `, data)
        return ServiceModel.create(service)
    }
    return new Promise()
}).then((data) => {
    console.log('SeviceModel has been created successfully, received data:', data)
    process.exit()
})