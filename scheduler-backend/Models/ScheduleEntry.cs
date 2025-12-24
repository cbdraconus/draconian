namespace Scheduler.Api.Models;

public class ScheduleEntry
{
    public Guid Id { get; set; }
    public Guid ScheduleId { get; set; }
    public Schedule? Schedule { get; set; }

    public string UserId { get; set; } = string.Empty;
    public ApplicationUser? User { get; set; }

    public Guid ShiftTypeId { get; set; }
    public ShiftType? ShiftType { get; set; }

    public DateTimeOffset StartTime { get; set; }
    public DateTimeOffset EndTime { get; set; }

    public Guid? AssignmentId { get; set; }
    public Assignment? Assignment { get; set; }

    public Guid? GrantId { get; set; }
    public Grant? Grant { get; set; }

    public string? Notes { get; set; }
}
