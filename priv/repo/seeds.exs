alias Acorn.Repo
alias Acorn.Wiki.Page

Repo.delete_all(Page)

Repo.insert! %Page{
    title: "Seeding",
    content: "Woohoo seeding",
    parent_id: 2
}