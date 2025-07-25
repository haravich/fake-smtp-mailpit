<script>
import NavSelected from "../components/NavSelected.vue";
import AjaxLoader from "./AjaxLoader.vue";
import CommonMixins from "../mixins/CommonMixins";
import { mailbox } from "../stores/mailbox";
import { pagination } from "../stores/pagination";

export default {
	components: {
		NavSelected,
		AjaxLoader,
	},

	mixins: [CommonMixins],

	props: {
		modals: {
			type: Boolean,
			default: false,
		},
	},

	emits: ["loadMessages"],

	data() {
		return {
			mailbox,
			pagination,
		};
	},

	methods: {
		reloadInbox() {
			const paginationParams = this.getPaginationParams();
			const reload = !paginationParams?.start;

			this.$router.push("/");
			if (reload) {
				// already on first page, reload messages
				this.loadMessages();
			}
		},

		loadMessages() {
			this.hideNav(); // hide mobile menu
			this.$emit("loadMessages");
		},

		markAllRead() {
			this.put(this.resolve(`/api/v1/messages`), { read: true }, (response) => {
				window.scrollInPlace = true;
				this.loadMessages();
			});
		},

		deleteAllMessages() {
			this.delete(this.resolve(`/api/v1/messages`), false, (response) => {
				pagination.start = 0;
				this.loadMessages();
			});
		},
	},
};
</script>

<template>
	<template v-if="!modals">
		<div v-if="mailbox.uiConfig.Label" class="text-center badge text-bg-primary py-2 my-2 w-100">
			<div class="text-truncate fw-normal" style="line-height: 1rem">
				{{ mailbox.uiConfig.Label }}
			</div>
		</div>

		<div class="list-group my-2" :class="mailbox.uiConfig.Label ? 'mt-0' : ''">
			<button class="list-group-item list-group-item-action active" @click="reloadInbox">
				<i v-if="mailbox.connected" class="bi bi-envelope-fill me-1"></i>
				<i v-else class="bi bi-arrow-clockwise me-1"></i>
				<span class="ms-1">Inbox</span>
				<span
					v-if="mailbox.unread"
					class="badge rounded-pill ms-1 float-end text-bg-secondary"
					title="Unread messages"
				>
					{{ formatNumber(mailbox.unread) }}
				</span>
			</button>

			<template v-if="!mailbox.selected.length">
				<button
					v-if="mailbox.skipConfirmations"
					class="list-group-item list-group-item-action"
					:disabled="!mailbox.messages_unread"
					@click="markAllRead"
				>
					<i class="bi bi-eye-fill me-1"></i>
					Mark all read
				</button>
				<button
					v-else
					class="list-group-item list-group-item-action"
					data-bs-toggle="modal"
					data-bs-target="#MarkAllReadModal"
					:disabled="!mailbox.messages_unread"
				>
					<i class="bi bi-eye-fill me-1"></i>
					Mark all read
				</button>
				<!-- checking if MessageRelay is defined prevents UI flicker while loading -->
				<template v-if="mailbox.uiConfig.MessageRelay && !mailbox.uiConfig.HideDeleteAllButton">
					<button
						v-if="mailbox.skipConfirmations"
						class="list-group-item list-group-item-action"
						:disabled="!mailbox.total"
						@click="deleteAllMessages"
					>
						<i class="bi bi-trash-fill me-1 text-danger"></i>
						Delete all
					</button>
					<button
						v-else
						class="list-group-item list-group-item-action"
						data-bs-toggle="modal"
						data-bs-target="#DeleteAllModal"
						:disabled="!mailbox.total"
					>
						<i class="bi bi-trash-fill me-1 text-danger"></i>
						Delete all
					</button>
				</template>
			</template>

			<NavSelected @load-messages="loadMessages" />
		</div>
	</template>

	<template v-else>
		<!-- Modals -->
		<div
			id="MarkAllReadModal"
			class="modal fade"
			tabindex="-1"
			aria-labelledby="MarkAllReadModalLabel"
			aria-hidden="true"
		>
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 id="MarkAllReadModalLabel" class="modal-title">Mark all messages as read?</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						This will mark {{ formatNumber(mailbox.unread) }} message<span v-if="mailbox.unread > 1"
							>s</span
						>
						as read.
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
						<button type="button" class="btn btn-success" data-bs-dismiss="modal" @click="markAllRead">
							Confirm
						</button>
					</div>
				</div>
			</div>
		</div>

		<div
			id="DeleteAllModal"
			class="modal fade"
			tabindex="-1"
			aria-labelledby="DeleteAllModalLabel"
			aria-hidden="true"
		>
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 id="DeleteAllModalLabel" class="modal-title">Delete all messages?</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						This will permanently delete {{ formatNumber(mailbox.total) }} message<span
							v-if="mailbox.total > 1"
							>s</span
						>.
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
						<button type="button" class="btn btn-danger" data-bs-dismiss="modal" @click="deleteAllMessages">
							Delete
						</button>
					</div>
				</div>
			</div>
		</div>
	</template>

	<AjaxLoader :loading="loading" />
</template>
