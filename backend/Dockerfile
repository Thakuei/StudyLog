# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.2.8
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

# 共通パッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl default-mysql-client libjemalloc2 libvips \
    build-essential default-libmysqlclient-dev git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Ruby bundler設定（デフォルトは開発モードにしておく）
ENV BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_FROZEN="false" \
    BUNDLE_DEPLOYMENT="false" \
    RAILS_ENV="development"

# Gemfile / Gemfile.lock をコピーして bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle config set frozen false && bundle install

# アプリケーションコードをコピー
COPY . .

# 非rootユーザー作成
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails

# Entrypointとポート設定
ENTRYPOINT ["/app/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

