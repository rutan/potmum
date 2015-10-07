module.exports = {
    entry: './frontend/index.js',
    output: {
        filename: './vendor/assets/javascripts/bundle.js'
    },
    module: {
        loaders: [
            {
                test: /\.jsx?$/,
                exclude: /(node_modules|bower_components)/,
                loader: 'babel'
            },
            {
                test: /\.vue$/,
                exclude: /(node_modules|bower_components)/,
                loader: 'vue'
            }
        ]
    }
}
