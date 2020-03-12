const inquirer = require('inquirer');
const fs = require('fs');

fs.readdir('cli/tasks/', (err, items) => {
    inquirer.prompt([
        {
            type: 'list',
            choices: items,
            name: 'task',
            message: 'Please select a task:'
        }
    ]).then((answers) => require('./tasks/' + answers.task))
})