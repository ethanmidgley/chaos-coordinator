defmodule Calendar.ProblemBuilder.Domain do
  alias Calendar.Entry
  alias Calendar.ProblemBuilder.Domain, as: EntryDomain

  @enforce_keys [:start_time, :end_time]
  defstruct [:start_time, :end_time]

  @type t :: %EntryDomain{
          start_time: DateTime.t(),
          end_time: DateTime.t()
        }

  @schedule_start ~T[09:00:00.000]
  @schedule_end ~T[17:00:00.000]
  @minimum_time_slot Duration.new!(minute: 15)

  @spec day_slots(Entry.t(), Date.t(), Time.t(), Time.t(), Duration.t()) :: [EntryDomain.t()]
  def day_slots(
        %Entry{} = e,
        date,
        start_time \\ @schedule_start,
        end_time \\ @schedule_end,
        interval \\ @minimum_time_slot
      ) do
    DateTime.new!(date, start_time)
    |> Stream.iterate(&DateTime.shift(&1, interval))
    |> Stream.map(fn s ->
      %EntryDomain{start_time: s, end_time: s |> DateTime.shift(e.duration)}
    end)
    |> Stream.take_while(fn x ->
      DateTime.to_time(x.end_time) |> Time.compare(end_time) != :gt
    end)
    |> Enum.to_list()
  end

  def span_days(%Entry{} = _e, []), do: []

  def span_days(%Entry{} = e, [params | rest]) do
    apply(Calendar.ProblemBuilder.Domain, :day_slots, [e | Tuple.to_list(params)]) ++
      span_days(e, rest)
  end

  def fixed_time(%Entry{} = e) do
    %EntryDomain{
      start_time: e.fixed_start_time,
      end_time: DateTime.shift(e.fixed_start_time, e.duration)
    }
  end

  def create(%Entry{} = e, days) do
    if e.fixed do
      [fixed_time(e)]
    else
      span_days(e, days)
    end
  end
end
