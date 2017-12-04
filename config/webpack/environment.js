const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.get('ExtractText')

environment.plugins.set(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    'window.Tether': 'tether',
  })
)

module.exports = environment
