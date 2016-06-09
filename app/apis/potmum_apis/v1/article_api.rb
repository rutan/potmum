module PotmumAPIs
  module V1
    class ArticleAPI < Grape::API
      resource :articles do
        desc 'Return public articles.'
        params do
          optional :limit, type: Integer, values: 1..100, default: 20, desc: 'page size.'
          optional :older_than, type: Integer, desc: 'UNIX timestamp (sec).'
        end
        get :newest, rabl: 'v1/articles/collection' do
          max_date = params[:older_than] ? Time.zone.new(params[:older_than]) : Time.zone.now
          @articles = Article.public_items
                             .includes(:user, :tags, :newest_revision)
                             .where(Article.arel_table[:published_at].lt(max_date))
                             .decorate
        end

        desc 'Return article.'
        params do
          requires :id, type: String, desc: 'Article id.'
        end
        route_param :id do
          get rabl: 'v1/articles/show' do
            @article = Article.published_items.find_by!(id: params[:id]).decorate
          end
        end
      end
    end
  end
end
