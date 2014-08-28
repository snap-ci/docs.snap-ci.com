module SidebarHelper
  def nesting_of(page)
    nesting = page.url.split('/').count
    nesting -= 1 if nesting > 1
    nesting += 1 if nesting == 0
    nesting
  end
end
