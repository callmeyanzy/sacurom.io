<?php
require_once __DIR__ . '/../bootstrap.php';

if (empty($_SESSION['user'])) {
    header('Location: ../login.php');
    exit;
}

$isAdmin = $_SESSION['user']['role'] === 'admin';

require_once __DIR__ . '/../models/Batch.php';

$msg = '';
$error = '';

// Only admins can edit batches
if ($_SERVER['REQUEST_METHOD'] === 'POST' && $isAdmin) {
    $token = $_POST['csrf_token'] ?? '';
    if (!csrf_check($token)) {
        $error = 'Invalid token.';
    } else {
        $action = $_POST['action'] ?? '';
        
        if ($action === 'create') {
            $name = trim($_POST['name'] ?? '');
            if ($name === '') {
                $error = 'Batch name is required.';
            } else {
                Batch::create($name);
                $msg = 'Batch created successfully.';
            }
        } elseif ($action === 'update') {
            $id = (int)($_POST['id'] ?? 0);
            $name = trim($_POST['name'] ?? '');
            if ($name === '') {
                $error = 'Batch name is required.';
            } else {
                Batch::update($id, $name);
                $msg = 'Batch updated successfully.';
            }
        } elseif ($action === 'delete') {
            $id = (int)($_POST['id'] ?? 0);
            Batch::delete($id);
            $msg = 'Batch deleted successfully.';
        }
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST' && !$isAdmin) {
    $error = 'You do not have permission to edit batches.';
}

$batches = Batch::all();

require __DIR__ . '/../views/layouts/header.php';
?>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="mb-1"><i class="fas fa-layer-group me-2 text-info"></i>Batches</h3>
        <p class="text-muted mb-0">Manage training batches</p>
    </div>
</div>

<?php if ($msg): ?>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <?php echo e($msg); ?>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<?php endif; ?>

<?php if ($error): ?>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <?php echo e($error); ?>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<?php endif; ?>

<?php if (!$isAdmin): ?>
<div class="alert alert-info">
    <i class="fas fa-info-circle me-2"></i>You are viewing the batch list. Only administrators can add or edit batches.
</div>
<?php endif; ?>

<div class="row">
    <div class="col-md-8">
        <div class="card dashboard-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Batch Name</th>
                                <th>Created At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($batches as $batch): ?>
                            <tr>
                                <td><?php echo $batch['id']; ?></td>
                                <td><?php echo e($batch['name']); ?></td>
                                <td><?php echo date('M d, Y', strtotime($batch['created_at'])); ?></td>
                                <td>
                                    <?php if ($isAdmin): ?>
                                    <button class="btn btn-sm btn-outline-primary" onclick="editBatch(<?php echo $batch['id']; ?>, '<?php echo e($batch['name']); ?>')">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <form method="post" class="d-inline" onsubmit="return confirm('Delete this batch?')">
                                        <input type="hidden" name="csrf_token" value="<?php echo e(csrf_token()); ?>">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<?php echo $batch['id']; ?>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                    <?php else: ?>
                                    <span class="text-muted">-</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <?php if ($isAdmin): ?>
    <div class="col-md-4">
        <div class="card dashboard-card">
            <div class="card-header bg-white border-0 pt-3">
                <h5 class="mb-0" id="formTitle">Add Batch</h5>
            </div>
            <div class="card-body">
                <form method="post" id="batchForm">
                    <input type="hidden" name="csrf_token" value="<?php echo e(csrf_token()); ?>">
                    <input type="hidden" name="action" id="formAction" value="create">
                    <input type="hidden" name="id" id="batchId">
                    
                    <div class="mb-3">
                        <label class="form-label">Batch Name</label>
                        <input type="text" class="form-control" name="name" id="batchName" required>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-success" id="submitBtn">
                            <i class="fas fa-plus me-1"></i>Add Batch
                        </button>
                        <button type="button" class="btn btn-outline-secondary mt-2" id="cancelBtn" style="display: none;" onclick="resetForm()">
                            Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <?php endif; ?>
</div>

<script>
function editBatch(id, name) {
    document.getElementById('formTitle').textContent = 'Edit Batch';
    document.getElementById('formAction').value = 'update';
    document.getElementById('batchId').value = id;
    document.getElementById('batchName').value = name;
    document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save me-1"></i>Update Batch';
    document.getElementById('cancelBtn').style.display = 'block';
}

function resetForm() {
    document.getElementById('formTitle').textContent = 'Add Batch';
    document.getElementById('formAction').value = 'create';
    document.getElementById('batchId').value = '';
    document.getElementById('batchName').value = '';
    document.getElementById('submitBtn').innerHTML = '<i class="fas fa-plus me-1"></i>Add Batch';
    document.getElementById('cancelBtn').style.display = 'none';
}
</script>

<?php require __DIR__ . '/../views/layouts/footer.php'; ?>
