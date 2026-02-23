<?php
require_once __DIR__ . '/../bootstrap.php';
if (empty($_SESSION['user'])) { header('Location: ../login.php'); exit; }
$isAdmin = $_SESSION['user']['role'] === 'admin';
require_once __DIR__ . '/../models/Competency.php';
$msg = '';
$error = '';
// Only admins can edit competencies
if ($_SERVER['REQUEST_METHOD'] === 'POST' && $isAdmin) {
    $token = $_POST['csrf_token'] ?? '';
    if (!csrf_check($token)) {
        $error = 'Invalid token.';
    } else {
        $action = $_POST['action'] ?? '';
        if ($action === 'create') {
            $code = trim($_POST['code'] ?? '');
            $title = trim($_POST['title'] ?? '');
            $description = trim($_POST['description'] ?? '');
            
            if ($code === '' || $title === '') {
                $error = 'Code and title are required.';
            } else {
                Competency::create($code, $title, $description);
                $msg = 'Competency created successfully.';
            }
        } elseif ($action === 'update') {
            $id = (int)($_POST['id'] ?? 0);
            $code = trim($_POST['code'] ?? '');
            $title = trim($_POST['title'] ?? '');
            $description = trim($_POST['description'] ?? '');
            
            if ($id <= 0 || $code === '' || $title === '') {
                $error = 'Code and title are required.';
            } else {
                Competency::update($id, $code, $title, $description);
                $msg = 'Competency updated successfully.';
            }
        } elseif ($action === 'delete') {
            $id = (int)($_POST['id'] ?? 0);
            if ($id > 0) {
                Competency::delete($id);
                $msg = 'Competency deleted successfully.';
            } else {
                $error = 'Invalid competency ID.';
            }
        }
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST' && !$isAdmin) {
    $error = 'You do not have permission to edit competencies.';
}
$items = Competency::all();
require __DIR__ . '/../views/layouts/header.php';
?>
<div class="row">
  <div class="col-md-<?php echo $isAdmin ? '8' : '12'; ?>">
    <h4><i class="fas fa-tasks me-2"></i>Competencies</h4>
    <?php if ($msg): ?><div class="alert alert-success"><?php echo e($msg); ?></div><?php endif; ?>
    <?php if ($error): ?><div class="alert alert-danger"><?php echo e($error); ?></div><?php endif; ?>
    
    <?php if (!$isAdmin): ?>
    <div class="alert alert-info">
      <i class="fas fa-info-circle me-2"></i>You are viewing the list of competencies. Only administrators can edit them.
    </div>
    <?php endif; ?>
    
    <table class="table table-bordered">
      <thead><tr><th>Code</th><th>Title</th><?php if ($isAdmin): ?><th>Actions</th><?php endif; ?></tr></thead>
      <tbody>
        <?php foreach ($items as $it): ?>
        <tr>
          <td><?php echo e($it['code']); ?></td>
          <td><?php echo e($it['title']); ?></td>
          <?php if ($isAdmin): ?>
          <td>
            <a class="btn btn-sm btn-primary" href="?edit=<?php echo $it['id']; ?>">Edit</a>
            <form style="display:inline" method="post"><input type="hidden" name="csrf_token" value="<?php echo e(csrf_token()); ?>"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<?php echo $it['id']; ?>"><button class="btn btn-sm btn-danger" onclick="return confirm('Delete?')">Delete</button></form>
          </td>
          <?php endif; ?>
        </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
  <?php if ($isAdmin): ?>
  <div class="col-md-4">
    <?php $editing = !empty($_GET['edit']) ? Competency::find((int)$_GET['edit']) : null; ?>
    <h4><?php echo $editing ? 'Edit' : 'Create'; ?> Competency</h4>
    <form method="post">
      <input type="hidden" name="csrf_token" value="<?php echo e(csrf_token()); ?>">
      <?php if ($editing): ?><input type="hidden" name="action" value="update"><input type="hidden" name="id" value="<?php echo $editing['id']; ?>"><?php else: ?><input type="hidden" name="action" value="create"><?php endif; ?>
      <div class="mb-2"><label class="form-label">Code</label><input class="form-control" name="code" value="<?php echo $editing ? e($editing['code']) : ''; ?>" required></div>
      <div class="mb-2"><label class="form-label">Title</label><input class="form-control" name="title" value="<?php echo $editing ? e($editing['title']) : ''; ?>" required></div>
      <div class="mb-2"><label class="form-label">Description</label><textarea class="form-control" name="description"><?php echo $editing ? e($editing['description']) : ''; ?></textarea></div>
      <div><button class="btn btn-success"><?php echo $editing ? 'Update' : 'Create'; ?></button></div>
    </form>
  </div>
  <?php endif; ?>
</div>
<?php require __DIR__ . '/../views/layouts/footer.php'; ?>
