defmodule Acorn.Wiki do
  @moduledoc """
  The Wiki context.
  """

  import Ecto.Query, warn: false
  alias Acorn.Repo

  alias Acorn.Wiki.Page
  alias Acorn.Wiki.Topic
  alias Acorn.Wiki.PageTopic

  @doc """
  Returns the list of pages.

  ## Examples

      iex> list_pages()
      [%Page{}, ...]

  """
  def list_pages(params, user_id) when params == %{} do
    Page
    |> with_owner(user_id)
    |> sorted(params["sort"])
    |> Repo.all()
    |> Repo.preload(:children)
    |> Repo.preload(:parent)
  end

  def list_pages(params, user_id) do
    IO.inspect(params, label: "The sort params: ")
    Page
    |> with_owner(user_id)
    |> with_tag(params["tag"])
    |> sorted(params["sort"])
    |> Repo.all()
  end

  defp with_owner(query, user_id) do
    from p in query,
      where: p.user_id == ^user_id
  end

  defp with_tag(query, tag) when tag != nil do
    from p in query,
      inner_join: pt in PageTopic,
      on: p.id==pt.page_id,
      inner_join: t in Topic,
      on: pt.topic_id==t.id,
      where: t.text==^tag
  end

  defp with_tag(query, _tag) do
    query
  end

  defp sorted(query, direction) when direction != nil do
    from p in query,
      order_by: {^String.to_atom(direction), p.updated_at}
  end

  defp sorted(query, _direction) do
    from p in query,
      order_by: [desc: p.updated_at]
  end


  @doc """
  Gets a single page.

  Raises `Ecto.NoResultsError` if the Page does not exist.

  ## Examples

      iex> get_page!(123)
      %Page{}

      iex> get_page!(456)
      ** (Ecto.NoResultsError)

  """
  def get_page!(id, user_id) do
    Repo.get_by!(Page, [id: id, user_id: user_id])
    |> Repo.preload(:children)
    |> Repo.preload(:parent)
    |> Repo.preload(:topics)
  end

  @doc """
  Creates a page.

  ## Examples

      iex> create_page(%{field: value})
      {:ok, %Page{}}

      iex> create_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

      attrs \\ %{}

  """
  def create_page(attrs \\ %{}) do
    topics = attrs["topics"] |> String.downcase() |> String.split(", ")
    attrs = Map.delete(attrs, "topics")
    IO.inspect(attrs, label: "from create_page at wiki: ")
    %Page{}
    |> Page.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, page} -> add_tag({:ok, page}, topics)
    end
  end

  @doc """
  Updates a page.

  ## Examples

      iex> update_page(page, %{field: new_value})
      {:ok, %Page{}}

      iex> update_page(page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_page(%Page{} = page, attrs) do
    topics = attrs["topics"] |> String.downcase() |> String.split(", ")
    attrs = Map.delete(attrs, "topics")
    update_tags(attrs["id"], topics)
    page
    |> Page.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a page.

  ## Examples

      iex> delete_page(page)
      {:ok, %Page{}}

      iex> delete_page(page)
      {:error, %Ecto.Changeset{}}

  """
  def delete_page(%Page{} = page) do
    # IO.inspect(page.topics)
    Enum.each(page.topics, &remove_tag(page.id, &1.id))
    Repo.delete(page)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking page changes.

  ## Examples

      iex> change_page(page)
      %Ecto.Changeset{source: %Page{}}

  """
  def change_page(%Page{} = page) do
    Page.changeset(page, %{})
  end

  alias Acorn.Wiki.Topic

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics(user_id) do
    subquery = from(p in Page, where: p.user_id == ^user_id, select: p.id)

    query = from t in Topic,
      join: pt in PageTopic,
      on: pt.topic_id==t.id,
      where: pt.page_id in subquery(subquery),
      group_by: [t.text, t.id],
      select: %{id: t.id, text: t.text, count: count(pt.id)}
    Repo.all(query)
  end

  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id), do: Repo.get!(Topic, id)

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{source: %Topic{}}

  """

  def change_topic(%Topic{} = topic) do
    Topic.changeset(topic, %{})
  end

  def add_tag({_, pagedata} = page, topics) when is_list(topics) do
    for topic_item <- topics do
      case Repo.get_by(Topic, text: topic_item) do
        nil -> create_topic(%{text: topic_item})
        |> case do
          {:ok, topic} -> add_tag(pagedata.id, topic.id)
        end
        topic -> add_tag(pagedata.id, topic.id)
      end
    end
    page
  end

  def add_tag(page_id, topic) when is_binary(topic) do

    case Repo.get_by(Topic, text: topic) do
      nil -> create_topic(%{text: topic})
      |> case do
        {:ok, topic} -> add_tag(page_id, topic.id)
      end
      topic -> add_tag(page_id, topic.id)
    end

  end

  def add_tag(page_id ,topic_id) do
    PageTopic.changeset(%PageTopic{}, %{page_id: page_id, topic_id: topic_id})
    |> Repo.insert()
  end

  def remove_tag(page_id, topic) when is_binary(topic) do
    case Repo.get_by(Topic, %{text: topic}) do
      nil -> nil
      topic -> remove_tag(page_id, topic.id)
    end
  end

  def remove_tag(page_id, topic_id) do
    case Repo.get_by(PageTopic, %{page_id: page_id, topic_id: topic_id}) do
      nil -> nil
      page_topic -> Repo.delete(page_topic)
    end
  end

  def update_tags(page_id, topics) when is_list(topics) do
    current_topics = Repo.get!(Page, page_id) |> Repo.preload(:topics) |> Map.get(:topics) |> Enum.map(& &1.text)
    new_topics = topics
    Enum.each(new_topics -- current_topics, &add_tag(page_id, &1))
    Enum.each(current_topics -- new_topics, &remove_tag(page_id, &1))

  end
end
