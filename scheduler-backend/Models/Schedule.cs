namespace Scheduler.Api.Models;

public class Schedule
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateOnly StartDate { get; set; }
    public DateOnly EndDate { get; set; }
    public ICollection<ScheduleEntry> Entries { get; set; } = new List<ScheduleEntry>();
}
