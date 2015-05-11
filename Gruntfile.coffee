module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # Updating the package manifest files
    noflo_manifest:
      update:
        files:
          'package.json': ['graphs/*', 'components/*']

    # Coding standards
    coffeelint:
      components: ['components/*.coffee']

  @loadNpmTasks 'grunt-noflo-manifest'
  @loadNpmTasks 'grunt-coffeelint'

  @registerTask 'build', ['noflo_manifest']
  @registerTask 'test', ['build', 'coffeelint']
