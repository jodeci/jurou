# Jurou / 翻譯蒟蒻

A collection of i18n related view helpers for Rails. Work in progress.

Lets say we have a model `Book`. `Book.genre` is a pre defined list of book genres, such as `fantasy, detective, romance, history, manga`. 

Most developers stick to English (at least the Latin alphabet) for such values. The thing is, your app more than often requires you to display them as `奇幻, 推理, 羅曼史, 歷史, 漫畫` or whatever your native language. 

Turns out this was a messier process than I imagined. To keep things DRY I put together Jurou for myself.

## Installation

Tested on Ruby 2.3.1 and Rails 5.

```
# Gemfile
gem "jurou"
```

```
$ bundle install
```

Generate the locale yml file. Defaults to your application's `default_locale` if `--locale` not specified.

```
$ rails generate jurou:install
$ rails generate jurou:install --locale ja
```

## Examples

Fill in the details in the generated locale file:

```
# config/locale/jurou.zh-TW.yml
zh-TW:
  jurou:
    book:
      genre:
        fantasy: 奇幻
        detective: 推理
        romance: 羅曼史
        history: 歷史
        manga: 漫畫
```

Use `jr_collection` in your form template:

```
# app/views/books/_form.html.slim
= simple_form_for @book do |f|
  = f.input :genre, collection: jr_collection(:genre, :book)
```

Jurou will then generate the collection hash for the form helper, resulting in the following HTML:

```
<select>
  <option value="fantasy">奇幻</option>
  <option value="detective">推理</option> 
  <option value="romance">羅曼史</option>
  <option value="history">歷史</option> 
  <option value="manga">漫畫</option> 
</select>
```

A few more to come.