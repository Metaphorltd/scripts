Set-Location C:\repos\OtaskiESAdminPortal
$statePath = "src/BinaryPlate.BlazorPlate.Tdap/States";
$interfacePath = "src/BinaryPlate.BlazorPlate.Tdap/Contracts/Consumers/App";
$clientPath = "src/BinaryPlate.BlazorPlate.Tdap/Consumers/HttpClients/App";
$dtoPath = "src/BinaryPlate.Shared";
$queryFilterPath = "src/BinaryPlate.BlazorPlate.Tdap/Models/QueryFilters";

$entities = @(
    @{Name="Setting";Plural="Settings"},
    @{Name="ChargePoint";Plural="ChargePoints"},
    @{Name="ServiceSession";Plural="ServiceSessions"}
)

function createDto($entity) {
    $dtoName = "$($entity.Name)Dto";
    $dtoContent = @"
namespace BinaryPlate.Shared;
public class $dtoName
{

}
"@;
    $dtoContent | Set-Content -Path "$dtoPath/$dtoName.cs";
}

function createInterface($entity) {
    $dtoName = "$($entity.Name)Dto";
    $interfaceName = "I$($entity.Name)Client";
    $interfaceContent = @"
namespace BinaryPlate.BlazorPlate.Tdap.Contracts.Consumers.App;
public interface $interfaceName
{
    Task<PagedList<$dtoName>> GetPaginated$($entity.Plural)(FilterableQuery request);
}
"@;
    $interfaceContent | Set-Content -Path "$interfacePath/$interfaceName.cs";
}

function createClient($entity) {
    $dtoName = "$($entity.Name)Dto";
    $interfaceName = "I$($entity.Name)Client";
    $clientName = "$($entity.Name)Client";
    $clientContent = @"
namespace BinaryPlate.BlazorPlate.Tdap.Consumers.HttpClients.App;
public class $clientName : BaseClient, $interfaceName
{
    public $clientName(IHttpService httpService,SnackbarApiExceptionProvider snackbar) : base(httpService,snackbar)
    {
    }
    public async Task<PagedList<$dtoName>> GetPaginated$($entity.Plural)(FilterableQuery request)
    {
        var query = CreatePageQuery<$dtoName>(request);
        if(!string.IsNullOrEmpty(request.SearchText))
        {
            query = query.Filter((s,f)=> f.Contains(f.ToLower(s.Name),request.SearchText));
        }
        var result = await GetODataResult<ODataResult<$dtoName>>(query);
        return new PagedList<$dtoName>(result, request);
    }
}
"@;
    $clientContent | Set-Content -Path "$clientPath/$clientName.cs";
}

function createState($entity) {
    $stateName = "$($entity.Name)ListState";
    $stateContent = @"
using BinaryPlate.BlazorPlate.Tdap.Models.QueryFilters;
namespace BinaryPlate.BlazorPlate.Tdap.States;

public class $stateName
(
    I$($entity.Name)Client $($entity.Name.ToLower())Client,
    SnackbarApiExceptionProvider snackbarApiExceptionProvider,
    NavigationManager navigationManager,
    BreadcrumbService breadcrumbService
) : BaseState
{
    public MudTable<$($entity.Name)Dto> Table;
    private readonly $($entity.Name)QueryFilter _get$($entity.Name)QueryFilter = new();
    private string SearchString { get; set; }
    public PagedList<$($entity.Name)Dto> $($entity.Name)Paginator = new();

    public void SetBreadCrumbItems()
    {
        breadcrumbService.SetBreadcrumbItems(breadcrumbItems:
        [
            new BreadcrumbItem(text: Resource.Home, href: "/"),
            new BreadcrumbItem(text: "Locations", href: "manage/$($entity.Plural.ToLower())", disabled: true)
        ]);
    }

    public async Task<TableData<$($entity.Name)Dto>> ServerReload(TableState state)
    {
        _get$($entity.Name)QueryFilter.SearchText = SearchString;

        _get$($entity.Name)QueryFilter.PageNumber = state.Page;

        _get$($entity.Name)QueryFilter.RowsPerPage = state.PageSize;

        _get$($entity.Name)QueryFilter.SortBy = state.SortDirection == SortDirection.None ? string.Empty : $"{state.SortLabel} {state.SortDirection}";

        var response = await Get$($entity.Plural)(_get$($entity.Name)QueryFilter);
        var tableData = new TableData<$($entity.Name)Dto>()
        {
            Items = response.Items,
            TotalItems = response.TotalRows
        };
        return tableData;
    }

    public void Filter$($entity.Plural)(string searchString)
    {
        SearchString = searchString;
        Table.ReloadServerData();
    }

    public void ShowDetail(Guid id)
    {
        navigationManager.NavigateTo("$($entity.Plural.ToLower())/{id}");
    }

    public async Task<PagedList<$($entity.Name)Dto>> Get$($entity.Plural)(FilterableQuery filter)
    {
        return $($entity.Name)Paginator = await $($entity.Name.ToLower())Client.GetPaginated$($entity.Plural)(filter);
    }
}
"@;
    $stateContent | Set-Content -Path "$statePath/$stateName.cs";
}

function createQueryFilter($entity) {
    $queryFilterName = "$($entity.Name)QueryFilter";
    $queryFilterContent = @"
namespace BinaryPlate.BlazorPlate.Tdap.Models.QueryFilters;
public class $queryFilterName : FilterableQuery
{

}
"@;
    $queryFilterContent | Set-Content -Path "$queryFilterPath/$queryFilterName.cs";
}

foreach ($entity in $entities) {
    createDto($entity);
    createInterface($entity);
    createClient($entity);
    createState($entity);
    createQueryFilter($entity);
}
