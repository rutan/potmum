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
                loader: 'babel',
                query: {
                    presets: ['es2015']
                }
            },
            {
                test: /\.vue$/,
                exclude: /(node_modules|bower_components)/,
                loader: 'vue'
            }
        ]
    }
}
