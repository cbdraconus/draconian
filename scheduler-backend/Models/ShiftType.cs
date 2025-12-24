namespace Scheduler.Api.Models;

public class ShiftType
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int Hours { get; set; }
    public bool IsActive { get; set; } = true;
    public ICollection<ScheduleEntry> ScheduleEntries { get; set; } = new List<ScheduleEntry>();
}
