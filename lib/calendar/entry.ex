defmodule Calendar.Entry do
  alias Calendar.Entry

  @enforce_keys [:title]
  defstruct [
    :title,
    :deadline,
    :fixed_start_time,
    dependencies: [],
    duration: Duration.new!(hour: 1),
    note: "",
    fixed: false,
    priority: 1
  ]

  @type t :: %Entry{
          title: String.t(),
          deadline: DateTime.t(),
          fixed_start_time: DateTime.t(),
          dependencies: [String.t()],
          duration: Duration.t(),
          note: String.t(),
          fixed: boolean(),
          priority: integer()
        }

  def add_dependency(%Entry{} = entry, dependency) do
    new_deps = entry.dependencies ++ [dependency]
    %{entry | dependencies: new_deps}
  end
end
