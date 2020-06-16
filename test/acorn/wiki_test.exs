defmodule Acorn.WikiTest do
  use Acorn.DataCase

  alias Acorn.Wiki

  describe "pages" do
    alias Acorn.Wiki.Page

    @valid_attrs %{content: "some content", related: %{}, tags: %{}, title: "some title"}
    @update_attrs %{content: "some updated content", related: %{}, tags: %{}, title: "some updated title"}
    @invalid_attrs %{content: nil, related: nil, tags: nil, title: nil}

    def page_fixture(attrs \\ %{}) do
      {:ok, page} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wiki.create_page()

      page
    end

    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert Wiki.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Wiki.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      assert {:ok, %Page{} = page} = Wiki.create_page(@valid_attrs)
      assert page.content == "some content"
      assert page.related == %{}
      assert page.tags == %{}
      assert page.title == "some title"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wiki.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      assert {:ok, %Page{} = page} = Wiki.update_page(page, @update_attrs)
      assert page.content == "some updated content"
      assert page.related == %{}
      assert page.tags == %{}
      assert page.title == "some updated title"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Wiki.update_page(page, @invalid_attrs)
      assert page == Wiki.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Wiki.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Wiki.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Wiki.change_page(page)
    end
  end

  describe "pages" do
    alias Acorn.Wiki.Page

    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{content: "some updated content", title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}

    def page_fixture(attrs \\ %{}) do
      {:ok, page} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wiki.create_page()

      page
    end

    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert Wiki.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Wiki.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      assert {:ok, %Page{} = page} = Wiki.create_page(@valid_attrs)
      assert page.content == "some content"
      assert page.title == "some title"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wiki.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      assert {:ok, %Page{} = page} = Wiki.update_page(page, @update_attrs)
      assert page.content == "some updated content"
      assert page.title == "some updated title"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Wiki.update_page(page, @invalid_attrs)
      assert page == Wiki.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Wiki.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Wiki.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Wiki.change_page(page)
    end
  end

  describe "topics" do
    alias Acorn.Wiki.Topic

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wiki.create_topic()

      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Wiki.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Wiki.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Wiki.create_topic(@valid_attrs)
      assert topic.text == "some text"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wiki.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{} = topic} = Wiki.update_topic(topic, @update_attrs)
      assert topic.text == "some updated text"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Wiki.update_topic(topic, @invalid_attrs)
      assert topic == Wiki.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Wiki.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Wiki.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Wiki.change_topic(topic)
    end
  end
end
