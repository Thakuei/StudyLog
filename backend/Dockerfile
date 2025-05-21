# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.2.8
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

# 共通パッケージ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl default-mysql-client libjemalloc2 libvips \
    build-essential default-libmysqlclient-dev git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# build-time でも RAILS_ENV を受け取る（デフォルト: development）
ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_PATH="/usr/local/bundle"

# Gemfile をコピーして、環境に応じて bundler 設定
COPY Gemfile Gemfile.lock ./

RUN if [ "$RAILS_ENV" = "production" ]; then \
      bundle config set deployment 'true' && \
      bundle config set without 'development test'; \
    else \
      bundle config set deployment 'false' && \
      bundle config set without ''; \
    fi && \
    bundle install

# アプリケーションコードをコピー
COPY . .

# 非rootユーザー
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /app
USER rails

# ポートを80で統一（Railway対応）
EXPOSE 80
ENTRYPOINT ["/app/bin/docker-entrypoint"]
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "80"]

