const fs = require('fs');
const ini = require('ini');

const settings = (() => {
    try {
        return ini.parse(fs.readFileSync('settings.ini', 'utf-8'));
    } catch (err) {
        switch(err.code) {
            case 'ENOENT':
                console.error(
                    'Error: settings.ini does not exist.', 
                    ' Please make sure that you created your settings.ini correctly,',
                    ' to create one, copy and rename the settings.ini.example, end set it up propperly'
                );
                break
            default:
                console.error('Error: There was a error trying to read the settings.ini. Received: ', err)
        }
        throw 'Error trying to read the settings.ini, cannot continue.'
    }
})();

module.exports = settings;
