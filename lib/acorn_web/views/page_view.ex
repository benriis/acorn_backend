defmodule AcornWeb.PageView do
  use AcornWeb, :view
  alias AcornWeb.PageView

  def render("index.json", %{pages: pages}) do
    %{data: render_many(pages, PageView, "pagefront.json")}
  end

  def render("show.json", %{page: page}) do
    %{data: render_one(page, PageView, "page.json")}
  end

  def render("pagefront.json", %{page: page}) do
    %{id: page.id,
      title: page.title}
  end

  def render("page.json", %{page: page}) do
    %{id: page.id,
      title: page.title,
      content: page.content,
      children: render_many(page.children, PageView, "children.json", as: :children),
      parent: render_one(page.parent, PageView, "parent.json", as: :parent),
      topics: render_many(page.topics, PageView, "topics.json", as: :topics),
      parent_id: page.parent_id,
      inserted_at: page.inserted_at,
      updated_at: page.updated_at}
  end

  def render("children.json", %{children: children}) do
    %{id: children.id,
      title: children.title
    }
  end

  def render("parent.json", %{parent: parent}) do
    %{id: parent.id,
      title: parent.title
    }
  end

  def render("topics.json", %{topics: topics}) do
    %{id: topics.id,
      text: topics.text
    }
  end
end
