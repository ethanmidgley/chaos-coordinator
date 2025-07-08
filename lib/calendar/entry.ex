# %Task{
# 	title: "Walk dog",
# 	description: "kinda obvious",
# 	duration: 60,
# 	deadline: tomorrow
# 	dependencies: [:a] # depends on task a beng complete first
# 	priority: 2 # 1-5 5 being the highest priority
# 	flexibility: true # this one may be ignored for now
# }

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

  # def generate_domain(%Entry{} = entry) do
  #   if entry.fixed do
  #     [
  #       %{
  #         start_time: entry.fixed_start_time,
  #         end_time: DateTime.shift(entry.fixed_start_time, entry.duration)
  #       }
  #     ]
  #   else
  #     # We need to generate domains up to the deadline basically
  #     # generate all the slots
  #     Stream.iterate()
  #     # filter based on schedule start and ends
  #     # interval by minimum_time_slot
  #     # https://hexdocs.pm/elixir/main/Duration.html#module-intervals
  #
  #     %{}
  #   end
  # end
end
