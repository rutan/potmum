var fs = require('fs');
var path = require('path');
var glob = require('glob');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var ManifestPlugin = require('webpack-manifest-plugin');

var paths = (function () {
    var rootPath = path.join(__dirname, './');
    return {
        root: rootPath,
        nodeModules: path.join(rootPath, './node_modules/'),
        src: path.join(rootPath, './frontend'),
        output: path.join(rootPath, './public/asset_pack')
    };
})();

require(path.join(paths.root, './data/generate-color-theme.js'));

var isProduction = process.env.RAILS_ENV === 'production' || process.env.NODE_ENV === 'production';
var fileNameRule = isProduction ? '[name]-[hash]' : '[name]';

module.exports = {
    entry: {
        bundle: [
            path.join(paths.src, '/assets.js'),
            path.join(paths.nodeModules, '/normalize.css/normalize.css'),
            path.join(paths.nodeModules, '/flexboxgrid/css/flexboxgrid.css'),
            path.join(paths.nodeModules, '/font-awesome/css/font-awesome.css'),
            path.join(paths.src, '/stylesheets/index.scss'),
            path.join(paths.src, '/index.js')
        ],
        vendor: [
            'babel-polyfill'
        ]
    },
    output: {
        path: paths.output,
        publicPath: isProduction ? '/asset_pack/' : 'http://localhost:8080/asset_pack/',
        filename: fileNameRule + '.js'
    },
    module: {
        loaders: [
            {
                test: /\.jsx?$/,
                exclude: /(node_modules)/,
                loader: 'babel',
                query: {
                    presets: ['es2015'],
                    plugins: ['transform-runtime']
                }
            },
            {
                test: /\.vue$/,
                exclude: /(node_modules)/,
                loader: 'vue'
            },
            {
                test: /\.s?css$/,
                loader: ExtractTextPlugin.extract(
                    'style',
                    'css!sass?sourceMap&includePaths[]=' + paths.nodeModules
                )
            },
            {
                test: /\.(png|jpg|gif|svg|ico)$/,
                loader: 'file?name=/' + fileNameRule + '.[ext]'
            },
            {
                test: /\/font-awesome\/.+\.(woff|woff2|ttf|eot|svg)(\?.+)?$/,
                loader: 'file?name=/' + fileNameRule + '.[ext]'
            }
        ]
    },
    plugins: [
        new ManifestPlugin({
            fileName: '../../webpack-manifest.json'
        }),
        new ExtractTextPlugin('bundle' + (isProduction ? '-[hash]' : '') + '.css')
    ]
};
