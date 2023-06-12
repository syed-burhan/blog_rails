class Post < ApplicationRecord
    has_many :comments, dependent: :destroy

    after_commit :flush_cache

    def self.cached_find(id)
        Rails.cache.fetch([name, id]) { find(id) }
    end

    def self.cached_all
        Rails.cache.fetch('posts_index') { all.order("created_at DESC").to_a }
    end

    def cached_comments_count
        Rails.cache.fetch([self, "comments_count"]) { comments.count }
    end

    def cached_comments
        Rails.cache.fetch([self, "comments"]) { comments.to_a }
    end

    def flush_cache
        Rails.cache.delete('posts_index')
        Rails.cache.delete([self.class.name, id])
    end
end
