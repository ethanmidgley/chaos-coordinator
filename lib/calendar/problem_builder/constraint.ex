defmodule Calendar.ProblemBuilder.Constraint do
  alias Calendar.Entry

  def deadline(%Entry{} = e) do
    if e.deadline != nil do
      {[e.title],
       fn slot ->
         DateTime.compare(slot.end_time, e.deadline) != :gt
       end}
    end
  end

  def priority(%Entry{} = e1, %Entry{} = e2) do
    cond do
      e1.priority == e2.priority ->
        nil

      e1.priority > e2.priority ->
        {[e1.title, e2.title],
         fn sooner, later -> DateTime.compare(sooner.end_time, later.start_time) != :gt end}

      e1.priority < e2.priority ->
        {[e1.title, e2.title],
         fn later, sooner -> DateTime.compare(sooner.end_time, later.start_time) != :gt end}
    end
  end

  def dependencies(%Entry{} = e) do
    e.dependencies
    |> Enum.map(fn dependency ->
      {[e.title, dependency],
       fn entry, depend_on -> DateTime.compare(depend_on.end_time, entry.start_time) != :gt end}
    end)
  end

  @doc """
  Creates a constraint that e2 cannot be ran during e1
  """
  def not_at_same_time(%Entry{} = e1, %Entry{} = e2) do
    {[e1.title, e2.title],
     fn e1, e2 ->
       DateTime.compare(e2.start_time, e1.start_time) == :lt ||
         DateTime.compare(e2.start_time, e1.end_time) != :lt
     end}
  end

  def all_diff_slot(entries) do
    for x <- entries, y <- entries, x.title != y.title do
      not_at_same_time(x, y)
    end
  end

  def enforce_priorities(entries) do
    for x <- entries, y <- entries, x.title != y.title do
      priority(x, y)
    end
  end

  def create(entries) do
    enforce_priorities(entries) ++
      all_diff_slot(entries) ++
      (Enum.map(entries, fn entry ->
         if entry.deadline != nil do
           [deadline(entry)]
         else
           []
         end ++
           dependencies(entry)
       end)
       |> Enum.concat())
  end
end
